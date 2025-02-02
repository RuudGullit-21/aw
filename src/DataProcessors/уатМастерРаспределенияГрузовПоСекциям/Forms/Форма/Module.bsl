
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// начало блока стандартных операций
	ДопПараметрыОткрытие = Новый Структура("ИмяФормы", ИмяФормы);
	уатЗащищенныеФункцииСервер.уатОбработкаФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	// конец блока стандартных операций
	
	Параметры.Свойство("СмешиватьГрузыВСекциях", СмешиватьГрузыВСекциях);
	
	ЗаполнитьТаблицуСекций();
	
	Если ТаблицаСекций.Количество() = 0 Тогда 
		Отказ = Истина; 
		Если Параметры.Свойство("ТС") Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Для %1 не указаны секции в карточке транспортного средства!'"), Параметры.ТС);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);  
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуЗаказов();
	
	ЗаполнитьТаблицуРазмещения();
	
	ОтобразитьТаблицуРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// начало блока стандартных операций
	уатЗащищенныеФункцииКлиент.уатОбработкаФормаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	// конец блока стандартных операций
	
	Если ВладелецФормы <> Неопределено
		И ВладелецФормы.ИмяФормы = "Документ.уатМаршрутныйЛист.Форма.ФормаДокумента" Тогда
		ЭтоМЛ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МастерРаспределенияВыбор(Элемент, Область, СтандартнаяОбработка)
	
	КлючРазмещения = ПолучитьКлючРазмещения(Область.Имя);
	
	Если КлючРазмещения.НомерСтроки = 3 Тогда
		КлючРазмещения.СтрокаСекции.Включена = НЕ КлючРазмещения.СтрокаСекции.Включена;
		
		КолВоСтрок = ТаблицаЗаказов.Количество();
		ОбластьСекции  = СтрШаблон("R2C%1:R%2C%1", КлючРазмещения.НомерКолонки, КолВоСтрок + 6);
		ОбластьЗаказов = СтрШаблон("R4C%1:R%2C%1", КлючРазмещения.НомерКолонки, КолВоСтрок + 3);

		Если КлючРазмещения.СтрокаСекции.Включена Тогда
			Область.Картинка = БиблиотекаКартинок.уатФлагВключен;
			ПокраситьОбластьТаблицы(ОбластьСекции, Новый Цвет(226, 226, 226), Новый Цвет(0, 0, 0));
			ПокраситьОбластьТаблицы(ОбластьЗаказов, Новый Цвет(255, 255, 255));
			
			СвободноВСекции = КлючРазмещения.СтрокаСекции.ОбъемСекции - КлючРазмещения.СтрокаСекции.ЗанятоВСекции;;
			Если СвободноВСекции > 0 Тогда
				ОбластьИтогов  = СтрШаблон("R%1C%2", КолВоСтрок + 6, КлючРазмещения.НомерКолонки);
				ПокраситьОбластьТаблицы(ОбластьИтогов, Новый Цвет(179, 243, 209));
			КонецЕсли;

		Иначе
			Область.Картинка = БиблиотекаКартинок.уатФлагВыключен;
			ПокраситьОбластьТаблицы(ОбластьСекции, Новый Цвет(242, 242, 242), Новый Цвет(169, 169, 169));
		КонецЕсли;
				
		СтандартнаяОбработка = Ложь;
	ИначеЕсли КлючРазмещения.GUIDСтроки = Неопределено
		ИЛИ КлючРазмещения.Секция = Неопределено 
		ИЛИ КлючРазмещения.Включена = Ложь Тогда 
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МастерРаспределенияПриИзмененииСодержимогоОбласти(Элемент, Область)
	
	КлючРазмещения = ПолучитьКлючРазмещения(Область.Имя);
	
	Если КлючРазмещения.GUIDСтроки = Неопределено
		ИЛИ КлючРазмещения.Секция = Неопределено
		ИЛИ КлючРазмещения.Включена = Ложь Тогда 
		Возврат;
	КонецЕсли;
	
	ИзменитьРаспределенноеКоличество(КлючРазмещения.GUIDСтроки, КлючРазмещения.Секция, Область.Значение);
	
	ОтобразитьТаблицуРаспределения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьРазмещение(Команда)
	
	СохранитьРазмещениеСервер(ЭтоМЛ);
		
	РезультатРазмещения = Новый Массив();
	Для Каждого ТекСтрока Из ТаблицаРазмещения Цикл 
		
		Если НЕ ЗначениеЗаполнено(ТекСтрока.Объем) Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеРазмещения = Новый Структура();
		ДанныеРазмещения.Вставить("GUIDСтроки", ТекСтрока.GUIDСтроки);
		ДанныеРазмещения.Вставить("Секция",     ТекСтрока.Секция);
		ДанныеРазмещения.Вставить("Объем",      ТекСтрока.Объем);
		РезультатРазмещения.Добавить(ДанныеРазмещения);
	КонецЦикла;
	
	Закрыть(РезультатРазмещения);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическоеРаспределение(Команда)
	
	АвтоматическоеРаспределениеСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуСекций()
	
	ТаблТС = Новый ТаблицаЗначений();
	ТаблТС.Колонки.Добавить("Ссылка",  Новый ОписаниеТипов("СправочникСсылка.уатТС"));
	ТаблТС.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число"));
	
	Если Параметры.Свойство("ТС") Тогда 
		НовСтрока = ТаблТС.Добавить();
		НовСтрока.Ссылка  = Параметры.ТС;
		НовСтрока.Порядок = 1;
	КонецЕсли;
	
	Если Параметры.Свойство("Прицеп1") Тогда 
		НовСтрока = ТаблТС.Добавить();
		НовСтрока.Ссылка  = Параметры.Прицеп1;
		НовСтрока.Порядок = 2;
	КонецЕсли;
	
	Если Параметры.Свойство("Прицеп2") Тогда 
		НовСтрока = ТаблТС.Добавить();
		НовСтрока.Ссылка  = Параметры.Прицеп2;
		НовСтрока.Порядок = 3;
	КонецЕсли;
	
	ЗапросСекции = Новый Запрос();
	ЗапросСекции.УстановитьПараметр("ТаблТС", ТаблТС);
	
	Если Константы.уатЕдиницаИзмеренияОбъема.Получить() = Перечисления.уатЕдиницыИзмеренияОбъема.Литр Тогда 
		ЗапросСекции.УстановитьПараметр("КоэфОбъемаКузова", 1000);
	Иначе 
		ЗапросСекции.УстановитьПараметр("КоэфОбъемаКузова", 1);
	КонецЕсли;
	
	ЗапросСекции.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблТС.Ссылка КАК Ссылка,
	|	ТаблТС.Порядок КАК Порядок
	|ПОМЕСТИТЬ ВТ_ТС
	|ИЗ
	|	&ТаблТС КАК ТаблТС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатСекцииТС.Владелец КАК ТС,
	|	уатСекцииТС.Ссылка КАК Секция,
	|	уатСекцииТС.Объем * &КоэфОбъемаКузова КАК ОбъемСекции
	|ИЗ
	|	Справочник.уатСекцииТС КАК уатСекцииТС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ТС КАК ВТ_ТС
	|		ПО уатСекцииТС.Владелец = ВТ_ТС.Ссылка
	|			И (НЕ уатСекцииТС.ПометкаУдаления)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТ_ТС.Порядок";
	
	СчКолонок = 3;
	
	ВыборкаСекции = ЗапросСекции.Выполнить().Выбрать();
	Пока ВыборкаСекции.Следующий() Цикл 
		НовСтрока = ТаблицаСекций.Добавить();
		НовСтрока.Включена            = Истина;
		НовСтрока.Секция              = ВыборкаСекции.Секция;
		НовСтрока.ОбъемСекции         = ВыборкаСекции.ОбъемСекции;
		НовСтрока.НомерКолонки        = СчКолонок;
		НовСтрока.ПредставлениеСекции = Строка(ВыборкаСекции.Секция);
		НовСтрока.ТС                  = ВыборкаСекции.ТС;
		СчКолонок = СчКолонок + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЗаказов()
	
	Если Не Параметры.Свойство("Заказы") Тогда 
		Возврат;
	КонецЕсли;
	
	СчСтрок = 4;
	Для Каждого ТекСтрока Из Параметры.Заказы Цикл 
		НовСтрока = ТаблицаЗаказов.Добавить();
		НовСтрока.GUIDСтроки  = ТекСтрока.GUIDСтроки;
		НовСтрока.НомерСтроки = СчСтрок;
		НовСтрока.Заказ       = Строка(ТекСтрока.Заказ.Номер);
		НовСтрока.Груз        = ТекСтрока.Груз;
		НовСтрока.Заказано    = ТекСтрока.Объем;
		
		СчСтрок = СчСтрок + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуРазмещения()
	
	Если Не Параметры.Свойство("Секции") Тогда 
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекСтрока Из Параметры.Секции Цикл 
		НовСтрока = ТаблицаРазмещения.Добавить();
		НовСтрока.GUIDСтроки = ТекСтрока.GUIDСтроки;
		НовСтрока.Секция     = ТекСтрока.Секция;
		НовСтрока.Объем      = ТекСтрока.Объем;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусРаспределения()
	
	Распределено = 0;
	Для Каждого ТекСтрока Из ТаблицаЗаказов Цикл 
		НайдСтроки = ТаблицаРазмещения.НайтиСтроки(Новый Структура("GUIDСтроки", ТекСтрока.GUIDСтроки));
		Для Каждого НайдСтрока Из НайдСтроки Цикл 
			Распределено = Распределено + НайдСтрока.Объем;
		КонецЦикла;
	КонецЦикла;
	
	Если Распределено = 0 Тогда 
		СтатусРаспределения = НСтр("ru = 'Для автоматического распределения грузов по секциям нажмите ""Распределить""'");
		Элементы.СтатусРаспределения.ЦветТекста = Новый Цвет(94, 94, 94);
	ИначеЕсли ТаблицаЗаказов.Итог("Заказано") > Распределено Тогда 
		СтатусРаспределения = НСтр("ru = 'Не все грузы размещены в секциях. Необходимо изменить размещение груза в секциях'");
		Элементы.СтатусРаспределения.ЦветТекста = Новый Цвет(193, 76, 76);
	Иначе 
		СтатусРаспределения = НСтр("ru = 'Все грузы размещены в секциях'");
		Элементы.СтатусРаспределения.ЦветТекста = Новый Цвет(94, 94, 94);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьТаблицуРаспределения()
	
	ОбновитьСтатусРаспределения();
	
	МастерРаспределения.Очистить();
	
	МакетТаблицы = Обработки.уатМастерРаспределенияГрузовПоСекциям.ПолучитьМакет("ШаблонТаблицыРаспределения");
	
	// Вывод шапки мастера.
	ОбластьШапка = МакетТаблицы.ПолучитьОбласть("Шапка|Груз");
	МастерРаспределения.Вывести(ОбластьШапка);
	
	ТаблицаТС = ТаблицаСекций.Выгрузить();
	ТаблицаТС.Свернуть("ТС");
	МассивТС = ТаблицаТС.ВыгрузитьКолонку("ТС");
	
	Для Каждого ТекТС Из МассивТС Цикл		
		ТаблицаСекцийТС = ТаблицаСекций.НайтиСтроки(Новый Структура("ТС", ТекТС));
		
		МассивЯчеекТС = Новый Массив();
		Для Каждого ТекСекция Из ТаблицаСекцийТС Цикл 
			
			ПараметрыЗаполнения = Новый Структура("ПредставлениеСекции", ТекСекция.ПредставлениеСекции);
			ОбластьСекция = МакетТаблицы.ПолучитьОбласть("Шапка|Секция");
			ЗаполнитьЗначенияСвойств(ОбластьСекция.Параметры, ТекСекция);
			ВыведеннаяОбласть = МастерРаспределения.Присоединить(ОбластьСекция);
			
			ИмяКолонкиТС = Лев(ВыведеннаяОбласть.Имя, СтрНайти(ВыведеннаяОбласть.Имя, ":") - 1);
			МассивЯчеекТС.Добавить(ИмяКолонкиТС);
			
			
			// Очистка итогов по каждой секции.
			ТекСекция.ЗанятоВСекции = 0;
		КонецЦикла;
		
		КолВоЯчеекТС = МассивЯчеекТС.Количество();
		Если КолВоЯчеекТС > 1 Тогда
			МастерРаспределения.Область(МассивЯчеекТС[0] + ":" + МассивЯчеекТС[КолВоЯчеекТС - 1]).Объединить();
		КонецЕсли;
	КонецЦикла;
		
	ОбластьИтоги = МакетТаблицы.ПолучитьОбласть("Шапка|ИтогиГруза");
	МастерРаспределения.Присоединить(ОбластьИтоги);
	
	// Вывод строк заказов.
	ИтераторЗаказов = 1;
	КолВоСекций     = ТаблицаСекций.Количество();
	Для Каждого ТекЗаказ Из ТаблицаЗаказов Цикл 
		ПараметрыЗаполнения = Новый Структура("Заказ, Груз", ТекЗаказ.Заказ, ТекЗаказ.Груз);
		ОбластьГруз = МакетТаблицы.ПолучитьОбласть("Строка|Груз");
		ЗаполнитьЗначенияСвойств(ОбластьГруз.Параметры, ПараметрыЗаполнения);
		МастерРаспределения.Вывести(ОбластьГруз);
		
		ВсегоРаспределено = 0;
		Для Каждого ТекСекция Из ТаблицаСекций Цикл 
			НайдСтроки = ТаблицаРазмещения.НайтиСтроки(Новый Структура("GUIDСтроки, Секция", ТекЗаказ.GUIDСтроки, ТекСекция.Секция));
			Если НайдСтроки.Количество() = 0 Тогда 
				КоличествоРаспределено = 0;
			Иначе 
				КоличествоРаспределено = НайдСтроки[0].Объем;
			КонецЕсли;
			
			ВсегоРаспределено = ВсегоРаспределено + КоличествоРаспределено;
			ТекСекция.ЗанятоВСекции = ТекСекция.ЗанятоВСекции + КоличествоРаспределено;
			
			ПараметрыЗаполнения = Новый Структура("РазмещеноВСекции", КоличествоРаспределено);
			ОбластьСекция = МакетТаблицы.ПолучитьОбласть("Строка|Секция");
			ЗаполнитьЗначенияСвойств(ОбластьСекция.Параметры, ПараметрыЗаполнения);
			МастерРаспределения.Присоединить(ОбластьСекция);
		КонецЦикла;
		
		НеРаспределено = ТекЗаказ.Заказано - ВсегоРаспределено;
		ПараметрыЗаполнения = Новый Структура();
		ПараметрыЗаполнения.Вставить("Заказано",       ТекЗаказ.Заказано);
		ПараметрыЗаполнения.Вставить("Распределено",   ВсегоРаспределено);
		ПараметрыЗаполнения.Вставить("НеРаспределено", НеРаспределено);
		
		ОбластьИтоги = МакетТаблицы.ПолучитьОбласть("Строка|ИтогиГруза");
		ЗаполнитьЗначенияСвойств(ОбластьИтоги.Параметры, ПараметрыЗаполнения);
		МастерРаспределения.Присоединить(ОбластьИтоги);
		
		Если НеРаспределено > 0 Тогда
			ОбластьИтогов  = СтрШаблон("R%1C%2", ИтераторЗаказов + 3, КолВоСекций + 5);
			ПокраситьОбластьТаблицыСервер(ОбластьИтогов, Новый Цвет(251, 184, 184));
		КонецЕсли;
		ИтераторЗаказов = ИтераторЗаказов + 1;
	КонецЦикла;
	
	// Вывод подвала мастера.
	ОбластьШапка = МакетТаблицы.ПолучитьОбласть("ИтогиСводно|Груз");
	МастерРаспределения.Вывести(ОбластьШапка);
	
	ИтераторСекций = 1;
	Для Каждого ТекСекция Из ТаблицаСекций Цикл 
		
		СвободноВСекции = ТекСекция.ОбъемСекции - ТекСекция.ЗанятоВСекции;
		ПараметрыЗаполнения = Новый Структура();
		ПараметрыЗаполнения.Вставить("ОбъемСекции",     ТекСекция.ОбъемСекции);
		ПараметрыЗаполнения.Вставить("ЗанятоВСекции",   ТекСекция.ЗанятоВСекции);
		ПараметрыЗаполнения.Вставить("СвободноВСекции", СвободноВСекции);
		
		ОбластьСекция = МакетТаблицы.ПолучитьОбласть("ИтогиСводно|Секция");
		ЗаполнитьЗначенияСвойств(ОбластьСекция.Параметры, ПараметрыЗаполнения);
		МастерРаспределения.Присоединить(ОбластьСекция);
		
		Если СвободноВСекции > 0 Тогда
			ОбластьИтогов  = СтрШаблон("R%1C%2", ИтераторЗаказов + 5, ИтераторСекций + 2);
			ПокраситьОбластьТаблицыСервер(ОбластьИтогов, Новый Цвет(179, 243, 209));
		КонецЕсли;
		
		Если НЕ ТекСекция.Включена Тогда
			ОбластьСекции = МастерРаспределения.Область(СтрШаблон("R3C%1", ИтераторСекций + 2));
			ОбластьСекции.Картинка = БиблиотекаКартинок.уатФлагВыключен;
			ОбластьСекции    = СтрШаблон("R2C%1:R%2C%1", ИтераторСекций + 2, ИтераторЗаказов + 5);
			ПокраситьОбластьТаблицыСервер(ОбластьСекции, Новый Цвет(242, 242, 242), Новый Цвет(169, 169, 169));
		КонецЕсли;
		
		ИтераторСекций = ИтераторСекций + 1;
	
	КонецЦикла;
	
	ОбластьИтоги = МакетТаблицы.ПолучитьОбласть("ИтогиСводно|ИтогиГруза");
	МастерРаспределения.Присоединить(ОбластьИтоги);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКлючРазмещения(Знач ИмяОбласти)
	
	КлючРазмещения = Новый Структура("GUIDСтроки,Секция,НомерСтроки,НомерКолонки,Включена,СтрокаСекции");
	
	ИмяОбласти = ВРег(ИмяОбласти);
	
	Если Не СтрНайти(ИмяОбласти, ":") = 0 Тогда 
		Возврат КлючРазмещения;
	КонецЕсли;
	
	// Отбросить первое R.
	ИмяОбласти = Прав(ИмяОбласти, СтрДлина(ИмяОбласти) - 1);
	
	ПозРазделитель = СтрНайти(ИмяОбласти, "C");
	
	Если ПозРазделитель = 0 Тогда 
		Возврат КлючРазмещения;
	КонецЕсли;
	
	Попытка
		НомерСтроки = Число(Лев(ИмяОбласти, ПозРазделитель - 1));
	Исключение
		НомерСтроки = 0;
	КонецПопытки;
	
	КлючРазмещения.НомерСтроки = НомерСтроки;
	
	Попытка
		НомерКолонки = Число(Прав(ИмяОбласти, СтрДлина(ИмяОбласти) - ПозРазделитель));
	Исключение
		НомерКолонки = 0;
	КонецПопытки;
	
	КлючРазмещения.НомерКолонки = НомерКолонки;
	
	Если НомерСтроки = 3 Тогда
		НайдСтроки = ТаблицаСекций.НайтиСтроки(Новый Структура("НомерКолонки", НомерКолонки));
		Если НайдСтроки.Количество() = 0 Тогда 
			Возврат КлючРазмещения;
		Иначе
			КлючРазмещения.Включена     = НайдСтроки[0].Включена;
			КлючРазмещения.СтрокаСекции = НайдСтроки[0];
			Возврат КлючРазмещения;
		КонецЕсли;
	КонецЕсли;
	
	НайдСтроки = ТаблицаЗаказов.НайтиСтроки(Новый Структура("НомерСтроки", НомерСтроки));
	Если НайдСтроки.Количество() = 0 Тогда 
		Возврат КлючРазмещения;
	КонецЕсли;
	
	КлючРазмещения.GUIDСтроки = НайдСтроки[0].GUIDСтроки;
	
	НайдСтроки = ТаблицаСекций.НайтиСтроки(Новый Структура("НомерКолонки", НомерКолонки));
	Если НайдСтроки.Количество() = 0 Тогда 
		Возврат КлючРазмещения;
	КонецЕсли;
	
	КлючРазмещения.Секция   = НайдСтроки[0].Секция;
	КлючРазмещения.Включена = НайдСтроки[0].Включена;
	
	Возврат КлючРазмещения;
	
КонецФункции // ПолучитьКлючРазмещения()

&НаКлиенте
Процедура ИзменитьРаспределенноеКоличество(GUIDСтроки, Секция, Количество)
	
	НайдСтроки = ТаблицаРазмещения.НайтиСтроки(Новый Структура("GUIDСтроки, Секция", GUIDСтроки, Секция));
	Если НайдСтроки.Количество() = 0 Тогда 
		СтрокаРазмещения = ТаблицаРазмещения.Добавить();
		СтрокаРазмещения.GUIDСтроки = GUIDСтроки;
		СтрокаРазмещения.Секция     = Секция;
	Иначе 
		СтрокаРазмещения = НайдСтроки[0];
	КонецЕсли;
	
	СтрокаРазмещения.Объем = Количество;
	
КонецПроцедуры

&НаСервере
Процедура АвтоматическоеРаспределениеСервер()
	
	ТаблицаРазмещения.Очистить();
	
	ЗаказыКРазмещению = Новый Массив();
	Для Каждого ТекСтрока Из ТаблицаЗаказов Цикл 
		ДанныеЗаказа = Новый Структура();
		ДанныеЗаказа.Вставить("Заказ", ТекСтрока.GUIDСтроки);
		ДанныеЗаказа.Вставить("Груз",  ТекСтрока.Груз);
		ДанныеЗаказа.Вставить("Объем", ТекСтрока.Заказано);
		ЗаказыКРазмещению.Добавить(ДанныеЗаказа);
	КонецЦикла;
	
	ТекущиеСекции = Новый ТаблицаЗначений();
	ТекущиеСекции.Колонки.Добавить("ТС",          Новый ОписаниеТипов("СправочникСсылка.уатТС"));
	ТекущиеСекции.Колонки.Добавить("Секция",      Новый ОписаниеТипов("СправочникСсылка.уатСекцииТС"));
	ТекущиеСекции.Колонки.Добавить("ОбъемСекции", Новый ОписаниеТипов("Число"));
	
	Для Каждого ТекСтрока Из ТаблицаСекций Цикл 
		Если НЕ ТекСтрока.Включена Тогда 
			Продолжить;
		КонецЕсли;
		
		НовСтрока = ТекущиеСекции.Добавить();
		НовСтрока.ТС          = ТекСтрока.Секция.Владелец;
		НовСтрока.Секция      = ТекСтрока.Секция;
		НовСтрока.ОбъемСекции = ТекСтрока.ОбъемСекции;
	КонецЦикла;
	
	РезультатРаспределения = Обработки.уатАРМЛогиста_уэ.ПолучитьДанныеРазмещенияЗаказовПоСекциям(
		ЗаказыКРазмещению,
		Новый ДеревоЗначений(),
		СмешиватьГрузыВСекциях,
		ТекущиеСекции
	);
	
	Если РезультатРаспределения.Размещено Тогда 
		Для Каждого ТекСтрока Из РезультатРаспределения.ТаблицаРазмещения Цикл 
			Для Каждого ТекЗаказ Из ТекСтрока.Заказы Цикл 
				НовСтрока = ТаблицаРазмещения.Добавить();
				НовСтрока.GUIDСтроки = ТекЗаказ.Заказ;
				НовСтрока.Секция     = ТекСтрока.Секция;
				НовСтрока.Объем      = ТекЗаказ.Объем;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	ОтобразитьТаблицуРаспределения();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьРазмещениеСервер(ЭтоМЛ)
	
	// Фиксация операции для статистики
	Если ЭтоМЛ Тогда
		ИмяКлючевойОперации = "уатОперации.РаспределениеПоСекциям.МаршрутныйЛист";
	Иначе
		ИмяКлючевойОперации = "уатОперации.РаспределениеПоСекциям.АРМЛогиста";
	КонецЕсли;

	ЦентрМониторинга.ЗаписатьОперациюБизнесСтатистики(ИмяКлючевойОперации, 1);

	
КонецПроцедуры

&НаКлиенте
Процедура ПокраситьОбластьТаблицы(ИмяОбласти, ЦветФона, ЦветТекста = Неопределено)
	
	ОбластьСекции = МастерРаспределения.Область(ИмяОбласти);
	ОбластьСекции.ЦветФона   = ЦветФона;
	
	Если ЦветТекста <> Неопределено Тогда
		ОбластьСекции.ЦветТекста = ЦветТекста;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПокраситьОбластьТаблицыСервер(ИмяОбласти, ЦветФона, ЦветТекста = Неопределено)
	
	ОбластьСекции = МастерРаспределения.Область(ИмяОбласти);
	ОбластьСекции.ЦветФона   = ЦветФона;
	
	Если ЦветТекста <> Неопределено Тогда
		ОбластьСекции.ЦветТекста = ЦветТекста;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
