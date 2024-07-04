#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура меняет коды переданного элемента и ближайшего элемента
//  в указанном направлении
//
// Параметры:
//  Элемент		 - СправочникСсылка.ШагиБюджетныхПроцессов	 - элемент, у которого меняем код
//  Направление	 - 											 - Число (+1, -1) - в какую сторону меняем код
//
Процедура СдвинутьЭлемент(Элемент, Направление) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ШагиБюджетныхПроцессов.Ссылка,
	|	ШагиБюджетныхПроцессов.Родитель,
	|	ШагиБюджетныхПроцессов.Код + &Смещение КАК Код,
	|	ШагиБюджетныхПроцессов.Владелец
	|ПОМЕСТИТЬ ТекущийЭлемент
	|ИЗ
	|	Справочник.ШагиБюджетныхПроцессов КАК ШагиБюджетныхПроцессов
	|ГДЕ
	|	ШагиБюджетныхПроцессов.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ШагиБюджетныхПроцессов.Ссылка,
	|	ВЫБОР
	|		КОГДА ШагиБюджетныхПроцессов.Ссылка = ТекущийЭлемент.Ссылка
	|			ТОГДА ТекущийЭлемент.Код
	|		ИНАЧЕ ШагиБюджетныхПроцессов.Код
	|	КОНЕЦ КАК КодПорядок,
	|	ВЫБОР
	|		КОГДА ШагиБюджетныхПроцессов.Ссылка = ТекущийЭлемент.Ссылка
	|			ТОГДА &Смещение
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ДопПорядок,
	|	ШагиБюджетныхПроцессов.Код
	|ИЗ
	|	ТекущийЭлемент КАК ТекущийЭлемент
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШагиБюджетныхПроцессов КАК ШагиБюджетныхПроцессов
	|		ПО ТекущийЭлемент.Родитель = ШагиБюджетныхПроцессов.Родитель
	|			И ТекущийЭлемент.Владелец = ШагиБюджетныхПроцессов.Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	КодПорядок,
	|	ДопПорядок");
	
	Запрос.УстановитьПараметр("Ссылка", Элемент);
	Запрос.УстановитьПараметр("Смещение", Направление);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Сч = 0;
	Пока Выборка.Следующий() Цикл
		Сч = Сч + 1;
		Если Сч <> Выборка.Код Тогда
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.Код = Сч;
			Объект.мРежимОбновленияКода = Истина;
			Объект.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура перенумеровывает всю группу элементов
//  применяется при переносе элемента в новую группу - перенумеровывается старая группа
//
// Параметры:
//  Родитель			 - 	 - СправочникСсылка.ШагиБюджетныхПроцессов
//  	- Группа, в рамках которой следует перенумеровать
//  ПереносимыйЭлемент	 - 	 - СправочникСсылка.ШагиБюджетныхПроцессов
//  	- Элемент, который переносим из группы
//
Процедура ПеренумероватьГруппуЭлементов(Родитель, ПереносимыйЭлемент) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ШагиБюджетныхПроцессов.Ссылка,
	|	ШагиБюджетныхПроцессов.Код
	|ИЗ
	|	Справочник.ШагиБюджетныхПроцессов КАК ШагиБюджетныхПроцессов
	|ГДЕ
	|	ШагиБюджетныхПроцессов.Родитель = &Родитель
	|	И ШагиБюджетныхПроцессов.Ссылка <> &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ШагиБюджетныхПроцессов.Код");
	
	Запрос.УстановитьПараметр("Родитель", Родитель);
	Запрос.УстановитьПараметр("Ссылка", ПереносимыйЭлемент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Сч = 0;
	Пока Выборка.Следующий() Цикл
		Сч = Сч + 1;
		Если Сч <> Выборка.Код Тогда
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.Код = Сч;
			Объект.мРежимОбновленияКода = Истина;
			Объект.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления УП 2.0.3.7
//  
//  Изменяет структуру хранения настроек действий шагов бюджетного процесса
//
Процедура ИзменитьХранениеНастроекДействий() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ШагиБюджетныхПроцессов.Ссылка КАК Ссылка,
	|	ШагиБюджетныхПроцессов.Действие КАК Действие,
	|	ШагиБюджетныхПроцессов.НастройкаДействия КАК НастройкаДействия,
	|	ШагиБюджетныхПроцессов.ПредставлениеНастройкиДействия КАК ПредставлениеНастройкиДействия
	|ИЗ
	|	Справочник.ШагиБюджетныхПроцессов КАК ШагиБюджетныхПроцессов
	|ГДЕ
	|	НЕ ШагиБюджетныхПроцессов.ЭтоГруппа
	|	И НЕ ШагиБюджетныхПроцессов.ПометкаУдаления
	|	И ШагиБюджетныхПроцессов.Действие В (
	|			ЗНАЧЕНИЕ(Перечисление.ТипыДействийШаговБюджетныхПроцессов.ВводЭкземпляраБюджета), 
	|			ЗНАЧЕНИЕ(Перечисление.ТипыДействийШаговБюджетныхПроцессов.УдалитьСогласованиеБюджетногоОтчета))";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НастройкиДействия = Выборка.НастройкаДействия.Получить();
		Если НастройкиДействия = Неопределено 
			Или НастройкиДействия.Колонки.Найти("Имя") <> Неопределено Тогда
			// Хранение соотвествует новой структуре
			Продолжить;
		КонецЕсли;
		
		НовыеНастройкиДействия = Новый ТаблицаЗначений;
		НовыеНастройкиДействия.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
		НовыеНастройкиДействия.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
		НовыеНастройкиДействия.Колонки.Добавить("Значение");
		
		ДоступныеНастройки = Новый Структура;
		ДоступныеНастройки.Вставить("ВидБюджета",    НСтр("en='Budget type';ru='Вид бюджета'"));
		ДоступныеНастройки.Вставить("Сценарий",      НСтр("en='Script';ru='Сценарий'"));
		ДоступныеНастройки.Вставить("Организация",   НСтр("en='Company';ru='Организация'"));
		ДоступныеНастройки.Вставить("Подразделение", НСтр("en='Department';ru='Подразделение'"));
		
		Для каждого Настройка Из ДоступныеНастройки Цикл
			СтрокаНастройкиДействия = НастройкиДействия.Найти(Настройка.Ключ);
			Если СтрокаНастройкиДействия <> Неопределено Тогда
				Если Настройка.Ключ = "Организация" 
					И Выборка.Действие = Перечисления.ТипыДействийШаговБюджетныхПроцессов.УдалитьСогласованиеБюджетногоОтчета Тогда
					ИмяНастройки = "Организации";
					ПредставлениеНастройки = НСтр("en='Companies';ru='Организации'");
					ЗначениеНастройки = Новый СписокЗначений();
					ЗначениеНастройки.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации");
					ЗначениеНастройки.Добавить(СтрокаНастройкиДействия.Значение);
				ИначеЕсли Настройка.Ключ = "Подразделение" 
					И Выборка.Действие = Перечисления.ТипыДействийШаговБюджетныхПроцессов.УдалитьСогласованиеБюджетногоОтчета Тогда
					ИмяНастройки = "Подразделения";
					ПредставлениеНастройки = НСтр("en='Departments';ru='Подразделения'");
					ЗначениеНастройки.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций");
					ЗначениеНастройки = Новый СписокЗначений();
					ЗначениеНастройки.Добавить(СтрокаНастройкиДействия.Значение);
				Иначе
					ИмяНастройки = Настройка.Ключ;
					ПредставлениеНастройки = Настройка.Значение;
					ЗначениеНастройки = СтрокаНастройкиДействия.Значение;
				КонецЕсли;
				НоваяСтрока = НовыеНастройкиДействия.Добавить();
				НоваяСтрока.Имя = ИмяНастройки;
				НоваяСтрока.Представление = ПредставлениеНастройки;
				НоваяСтрока.Значение = ЗначениеНастройки;
			КонецЕсли;
		КонецЦикла;
		
		ШагБюджетногоПроцесса = Выборка.Ссылка.ПолучитьОбъект();
		ШагБюджетногоПроцесса.НастройкаДействия = Новый ХранилищеЗначения(НовыеНастройкиДействия);
		ШагБюджетногоПроцесса.ПредставлениеНастройкиДействия = 
			Перечисления.ТипыДействийШаговБюджетныхПроцессов.ПолучитьПредставлениеДействия(НовыеНастройкиДействия);
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ШагБюджетногоПроцесса);
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления УП 2.0.4.6
//  
//  Действия СогласованиеБюджетногоОтчета преобразуются в Прочие
//
Процедура ПреобразоватьСогласованияБюджетныхОтчетовВПрочие() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ШагиБюджетныхПроцессов.Ссылка
	|ИЗ
	|	Справочник.ШагиБюджетныхПроцессов КАК ШагиБюджетныхПроцессов
	|ГДЕ
	|	ШагиБюджетныхПроцессов.Действие = &Действие
	|	И НЕ ШагиБюджетныхПроцессов.ЭтоГруппа
	|	И НЕ ШагиБюджетныхПроцессов.ПометкаУдаления";
	Запрос.УстановитьПараметр("Действие", Перечисления.ТипыДействийШаговБюджетныхПроцессов.УдалитьСогласованиеБюджетногоОтчета);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НастройкиКонтрольныхОтчетов = Новый ТаблицаЗначений;
	НастройкиКонтрольныхОтчетов.Колонки.Добавить("ВидБюджета");
	НастройкиКонтрольныхОтчетов.Колонки.Добавить("Сценарий");
	НастройкиКонтрольныхОтчетов.Колонки.Добавить("Организации");
	НастройкиКонтрольныхОтчетов.Колонки.Добавить("Подразделения");
	НастройкиКонтрольныхОтчетов.Колонки.Добавить("ПредставлениеОранизации");
	НастройкиКонтрольныхОтчетов.Колонки.Добавить("ПредставлениеПодразделения");
	НастройкиКонтрольныхОтчетов.Колонки.Добавить("ДанныеВПодготовке");
	НастройкиКонтрольныхОтчетов.Колонки.Добавить("ДанныеКУтверждению");
	
	Пока Выборка.Следующий() Цикл
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.Действие = Перечисления.ТипыДействийШаговБюджетныхПроцессов.Прочее;
		
		НастройкиДействия = Объект.НастройкаДействия.Получить();
		
		// Преобразуем настройки действия в настройки контрольных отчетов
		НастройкиКонтрольныхОтчетов.Очистить();
		НоваяСтрока = НастройкиКонтрольныхОтчетов.Добавить();
		Для каждого Параметр Из НастройкиДействия Цикл
			НоваяСтрока[Параметр.Имя] = Параметр.Значение;
			Если Параметр.Имя = "Подразделения" Тогда
				НоваяСтрока["ПредставлениеПодразделения"] = Строка(Параметр.Значение);
			КонецЕсли;
			Если Параметр.Имя = "Организации" Тогда
				НоваяСтрока["ПредставлениеОранизации"] = Строка(Параметр.Значение);
			КонецЕсли;
		КонецЦикла;
		
		Объект.НастройкаДействия = Неопределено;
		Объект.НастройкиКонтрольныхОтчетов = Новый ХранилищеЗначения(НастройкиКонтрольныхОтчетов);
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли