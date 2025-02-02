
#Область ОписаниеПеременных
	
&НаКлиенте
Перем мСчетчикДокументСформирован;

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриОткрытии" формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	мСчетчикДокументСформирован = 0;
		
	УстановитьВидимостьРадиуса();
	
	ПодключитьОбработчикОжидания("ПриИзмененииГеометрииФиксацииПосещения", 0.1, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.Параметры.Свойство("Адрес"  , Адрес);
	ЭтаФорма.Параметры.Свойство("Широта" , АдресШирота);
	ЭтаФорма.Параметры.Свойство("Долгота", АдресДолгота);
	Если ЭтаФорма.Параметры.Свойство("ГеометрияФиксацииПосещения", ГеометрияФиксацииПосещения) Тогда
	    Элементы.ГеометрияФиксацииПосещения.Видимость = Истина;
		Если Не ЗначениеЗаполнено(ГеометрияФиксацииПосещения) Тогда
			ГеометрияФиксацииПосещения = Перечисления.ItobВидыГеометрииФиксацииПосещения.Окружность;
		КонецЕсли;
	Иначе	
	    Элементы.ГеометрияФиксацииПосещения.Видимость = Ложь;
	КонецЕсли;
	Если ЭтаФорма.Параметры.Свойство("РадиусФиксацииПосещения", РадиусФиксацииПосещения) Тогда
	    Элементы.РадиусФиксацииПосещения.Видимость = Истина;
	Иначе	
	    Элементы.РадиусФиксацииПосещения.Видимость = Ложь;
	КонецЕсли;
	ЭтаФорма.Параметры.Свойство("ПунктНазначения", ПунктНазначения);
	ТочкиПунктовНазначенийСФормы = Неопределено;
	Если ЭтаФорма.Параметры.Свойство("ТочкиПунктовНазначений", ТочкиПунктовНазначенийСФормы) Тогда
		Для Каждого ТочкаПунктовНазначений Из ТочкиПунктовНазначенийСФормы Цикл
		    ЗаполнитьЗначенияСвойств(ТочкиПунктовНазначений.Добавить(), ТочкаПунктовНазначений);
		КонецЦикла; 
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 10
	               |	ItobМестоположенияПоУмолчанию.Ссылка КАК Ссылка,
	               |	ItobМестоположенияПоУмолчанию.Код,
	               |	ItobМестоположенияПоУмолчанию.Представление КАК Представление,
	               |	ItobМестоположенияПоУмолчанию.Наименование КАК Наименование,
	               |	ItobМестоположенияПоУмолчанию.Масштаб,
	               |	ItobМестоположенияПоУмолчанию.Широта,
	               |	ItobМестоположенияПоУмолчанию.Долгота
	               |ИЗ
	               |	Справочник.ItobМестоположенияПоУмолчанию КАК ItobМестоположенияПоУмолчанию
	               |ГДЕ
	               |	ItobМестоположенияПоУмолчанию.Широта <> 0
	               |	И ItobМестоположенияПоУмолчанию.Долгота <> 0
	               |	И ItobМестоположенияПоУмолчанию.Масштаб <> 0
	               |	И (НЕ ItobМестоположенияПоУмолчанию.ПометкаУдаления)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Наименование";
				   
	Счетчик = 1;
	
	СохраненноеМестоположение = ПрочитатьНастройкуПользователя("НастройкиКарты", "МестоположениеПоУмолчанию");
	ТекущееМестоположение = Неопределено;
	Если ЗначениеЗаполнено(СохраненноеМестоположение) Тогда
		ТекущееМестоположение = СохраненноеМестоположение;
				
	КонецЕсли;
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НовКоманда = ЭтаФорма.Команды.Добавить("НажатиеНаКнопку"+Счетчик+"ВыбораКарты");
		НовКоманда.Действие = "Подключаемый_НажатиеНаКнопкуВыбораКарты";
		НовКоманда.Заголовок = Выборка.Представление;
		НовКоманда.Подсказка = НСтр("ru = 'Выбрать местоположение'")+" """+Выборка.Представление+"""";
		
		НовКнопка = ЭтаФорма.Элементы.Добавить(
			"к_"+Выборка.Код, Тип("КнопкаФормы"), ЭтаФорма.Элементы.ПодменюВыборКарты);
		НовКнопка.ИмяКоманды = НовКоманда.Имя;
		НовКнопка.Заголовок = Выборка.Представление;
		
		Счетчик = Счетчик + 1;
		
		Если НЕ ЗначениеЗаполнено(ТекущееМестоположение) Тогда
			ТекущееМестоположение = Выборка.Ссылка;
		
		КонецЕсли;
		
		Если ТекущееМестоположение = Выборка.Ссылка Тогда
			НовКнопка.Пометка = Истина;
			
			МестоположениеМасштаб = Выборка.Масштаб;
			МестоположениеШирота = Выборка.Широта;
			МестоположениеДолгота = Выборка.Долгота;			
		
		КонецЕсли;
	
	КонецЦикла;
	
	ВебСсылкаСервер = "http://"+Константы.ItobАдресСервисаCsmSvc.Получить()+"/map/";
			
	АтрибутыКарты = "";
	Если ПроверитьКоординаты(АдресШирота, АдресДолгота) Тогда	
		ТекстСкрипта = ПолучитьСкриптТочкаНаКарте(АдресШирота, АдресДолгота, ВебСсылкаСервер);
		АтрибутыКарты = 
			"firstZoom = "+Формат(15,"ЧГ=0")+";
			|firstLat = "+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(АдресШирота)+";
			|firstLon = "+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(АдресДолгота)+";
			|"+ТекстСкрипта;		
		
	ИначеЕсли ПроверитьКоординаты(МестоположениеМасштаб, МестоположениеШирота, МестоположениеДолгота) Тогда	
		АтрибутыКарты = 
			"firstZoom = "+Формат(МестоположениеМасштаб,"ЧГ=0")+";
			|firstLat = "+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(МестоположениеШирота)+";
			|firstLon = "+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(МестоположениеДолгота)+";";					
	КонецЕсли;
		
	АтрибутыКарты = АтрибутыКарты+"
		|disable_double_click=true;";
	
	ПолеHTML = ItobОперативныйМониторинг.ПолучитьАдресКарты(АтрибутыКарты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ВыборМестоположенияНаКартеОбработкаВыбораАдреса" Тогда
		ВыборМестоположенияНаКартеОбработкаВыбораАдреса(Параметр);
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "ДокументСформирован" поля HTML "ПолеHTML".
//
&НаКлиенте
Процедура ПолеHTMLДокументСформирован(Элемент)
		
	Если Элементы.ПолеHTML.Документ.readyState = "complete" Тогда
		мСчетчикДокументСформирован = мСчетчикДокументСформирован + 1;
		Элементы.КнопкаОК.Доступность = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция ПолучитьВидыГеометрииФиксацииПосещения()
	
	Результат = Новый Структура;	
	ПеречислениеВидыГеометрииФиксацииПосещения = Перечисления.ItobВидыГеометрииФиксацииПосещения;
	Результат.Вставить("ПустаяСсылка", ПеречислениеВидыГеометрииФиксацииПосещения.ПустаяСсылка());
	Результат.Вставить("Окружность", ПеречислениеВидыГеометрииФиксацииПосещения.Окружность);
	Результат.Вставить("Полигон", ПеречислениеВидыГеометрииФиксацииПосещения.Полигон);
	
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если мСчетчикДокументСформирован < 1
		 ИЛИ НЕ Элементы.ПолеHTML.Документ.readyState = "complete" Тогда
		
		Возврат;	
	КонецЕсли;
	
	Попытка
		СтрокаСобытия = ДанныеСобытия.Element.value;
	Исключение
		СтрокаСобытия = "";
	КонецПопытки;	
	
	Если Лев(СтрокаСобытия, 17) = "PointRadiusResult" Тогда
		// Получение радиуса с карты
		РадиусФиксацииПосещения = Число(Сред(СтрокаСобытия,19));
	ИначеЕсли ДанныеСобытия.Element.id = "event_to_1c"
		И ЗначениеЗаполнено(СтрокаСобытия)
		И Лев(СтрокаСобытия, 16) = "ondblclick_event" Тогда
		
		// Двойной клик
		
		Координаты = СтрЗаменить(СтрокаСобытия, ",", Символы.ПС);
		КоординатаХ = СтрПолучитьСтроку(Координаты, 2);
		КоординатаУ = СтрПолучитьСтроку(Координаты, 3);
		
		ВидыГеометрииФиксацииПосещения = ПолучитьВидыГеометрииФиксацииПосещения();
		
		Если ГеометрияФиксацииПосещения = ВидыГеометрииФиксацииПосещения.ПустаяСсылка
			ИЛИ ГеометрияФиксацииПосещения = ВидыГеометрииФиксацииПосещения.Окружность Тогда
			// Обрабатываем точку и радиус фиксации.
			
			ТекстСкрипта = 
				"var px = new OpenLayers.Pixel("+Формат(КоординатаХ,"ЧРД=.; ЧГ=0")+","+Формат(КоординатаУ,"ЧРД=.; ЧГ=0")+");
				|var pt = m_map.getLonLatFromPixel(px);
				|pt.transform(m_map.getProjectionObject(), m_map.displayProjection);
				|document.form.result.value = pt.toShortString();
				|pt = null;";
				
			ItobОперативныйМониторингКлиент.ВыполнитьСкриптНаПолеHTML(Элементы.ПолеHTML, ТекстСкрипта);
			
			СтрокаКоординат = Элементы.ПолеHTML.Документ.form.result.value;
			СтрокаКоординат = СтрЗаменить(СтрокаКоординат,",",Символы.ПС);
				
			АдресШирота  = Число(СокрЛП(СтрПолучитьСтроку(СтрокаКоординат,2)));	
			АдресДолгота = Число(СокрЛП(СтрПолучитьСтроку(СтрокаКоординат,1)));	
				
			Если ГеометрияФиксацииПосещения = ВидыГеометрииФиксацииПосещения.ПустаяСсылка
				 ИЛИ РадиусФиксацииПосещения = 0 Тогда
				 
				ПоказатьТочкуАдресаНаКарте(АдресШирота,АдресДолгота);
			Иначе
				ItobОперативныйМониторингКлиент.ВыполнитьСкриптНаПолеHTML(Элементы.ПолеHTML,
					"move_pointcircle("+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(АдресШирота)+", "
									   +ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(АдресДолгота)+", "
									   +Формат(РадиусФиксацииПосещения,"ЧРД=.; ЧГ=0")+");");
			КонецЕсли; 		
		Иначе
			// Обрабатываем полигон		
			ТекстСкрипта = ItobГеографическиеЗоныВызовСервера.ПолучитьСкриптОтображенияГеографическойЗоныСервер(ПунктНазначения, Истина, Неопределено);
			ItobОперативныйМониторингКлиент.ВыполнитьСкриптНаПолеHTML(Элементы.ПолеHTML, ТекстСкрипта);			
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РадиусФиксацииПосещенияПриИзменении(Элемент)
	
	Если мСчетчикДокументСформирован < 1
		 ИЛИ НЕ Элементы.ПолеHTML.Документ.readyState = "complete" Тогда
		
		Возврат;	
	КонецЕсли;
	
	ТекстСкрипта = ГеометрияФиксацииПосещенияПриИзмененииНаСервере();
	ItobОперативныйМониторингКлиент.ВыполнитьСкриптНаПолеHTML(Элементы.ПолеHTML, ТекстСкрипта);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АвтомасштабКарты(Команда)
	
	АвтоматическиМасштабироватьКарту();
	
КонецПроцедуры

// Процедура - обработчик команды "УвеличитьКарту".
//
&НаКлиенте
Процедура УвеличитьКарту(Команда)
	
	Если мСчетчикДокументСформирован < 1
		 ИЛИ НЕ Элементы.ПолеHTML.Документ.readyState = "complete" Тогда
		
		Возврат;	
	КонецЕсли;
	
	ТекстСкрипта = "m_map.zoomIn();";
	ItobОперативныйМониторингКлиент.ВыполнитьСкриптНаПолеHTML(Элементы.ПолеHTML, ТекстСкрипта);	
	
КонецПроцедуры

// Процедура - обработчик команды "УменьшитьКарту".
//
&НаКлиенте
Процедура УменьшитьКарту(Команда)
	
	Если мСчетчикДокументСформирован < 1
		 ИЛИ НЕ Элементы.ПолеHTML.Документ.readyState = "complete" Тогда
		
		Возврат;	
	КонецЕсли;

	ТекстСкрипта = "m_map.zoomOut();";
	ItobОперативныйМониторингКлиент.ВыполнитьСкриптНаПолеHTML(Элементы.ПолеHTML, ТекстСкрипта);	
	
КонецПроцедуры

// Процедура - обработчик команды "КомандаОК".
//
&НаКлиенте
Процедура КомандаОК(Команда)
	
	СохранитьТочкиВТаблицу();
	Результат = КомандаОКНаСервере();
	Закрыть(Результат);		
	Если НЕ Результат.СообщениеОбОшибке = "" Тогда
		ПоказатьПредупреждение(, Результат.СообщениеОбОшибке, 10, НСтр("ru = 'Некорректные данные!'"));
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция КомандаОКНаСервере()
	
	Результат = Новый Структура;
	Результат.Вставить("Результат", Истина);
	Результат.Вставить("Адрес", Адрес);
	Результат.Вставить("Широта", АдресШирота);
	Результат.Вставить("Долгота", АдресДолгота);
	
	Результат.Вставить("СообщениеОбОшибке", "");
	
	Если ГеометрияФиксацииПосещения = Перечисления.ItobВидыГеометрииФиксацииПосещения.Окружность Тогда
		Результат.Вставить("ГеометрияФиксацииПосещения", ГеометрияФиксацииПосещения);
		Результат.Вставить("РадиусФиксацииПосещения", РадиусФиксацииПосещения);
		Результат.Вставить("ИспользоватьРадиусФиксацииПосещения", Истина);
	ИначеЕсли ГеометрияФиксацииПосещения = Перечисления.ItobВидыГеометрииФиксацииПосещения.Полигон Тогда
		Результат.Вставить("ГеометрияФиксацииПосещения", ГеометрияФиксацииПосещения);
		Результат.Вставить("ТочкиПунктовНазначений", ТочкиПунктовНазначений);
		
		ТочкиПунктовНазначенийТаблица = ТочкиПунктовНазначений.Выгрузить();
		МассивШирота = ТочкиПунктовНазначенийТаблица.ВыгрузитьКолонку("Широта");
		МассивДолгота = ТочкиПунктовНазначенийТаблица.ВыгрузитьКолонку("Долгота");
		ПараметрыГеозоны = ItobГеографическиеЗоны.ПараметрыПроверяемойЗоны();
		ПараметрыГеозоны.ШиротыЗоны = МассивШирота;
		ПараметрыГеозоны.ДолготыЗоны = МассивДолгота;
		Если НЕ ItobГеографическиеЗоны.ТочкаВГеозоне(АдресШирота, АдресДолгота, ПараметрыГеозоны) Тогда
			Результат.СообщениеОбОшибке = НСтр("ru = 'Координаты не входят в географическую зону точки!'");
		КонецЕсли; 
	КонецЕсли; 
	
	
	Возврат Результат;
	
КонецФункции 
  
// Процедура - обработчик команды "НажатиеНаКнопку10ВыбораКарты".
//
&НаКлиенте
Процедура Подключаемый_НажатиеНаКнопкуВыбораКарты(Команда)	
		
	ИмяКоманды = СтрЗаменить(Команда.Имя,"НажатиеНаКнопку","");
	ИмяКоманды = СтрЗаменить(ИмяКоманды,"ВыбораКарты","");
	
	ИзменитьПодменюВыбораМестоположенияНаСервере(Число(ИмяКоманды));
		
	АвтоматическиМасштабироватьКарту();	
	
КонецПроцедуры // НажатиеНаКнопку10ВыбораКарты()

&НаКлиенте
Процедура НайтиАдрес(Команда)
	
	АдресСтрока = ?(СтрДлина(Элементы.Адрес.ВыделенныйТекст) > 0, Элементы.Адрес.ВыделенныйТекст, Адрес);
	ItobРаботаСКартойКлиент.НачатьПрямоеГеокодирование(АдресСтрока, ЭтотОбъект);	
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Чтение настроек пользователя
//
&НаСервере
Функция ПрочитатьНастройкуПользователя(Раздел, Настройка)

	Возврат ХранилищеОбщихНастроек.Загрузить(Раздел, Настройка);	

КонецФункции // ПрочитатьНастройкуПользователя()

// Процедура изменяет подменю местоположения.
//
&НаСервере
Процедура ИзменитьПодменюВыбораМестоположенияНаСервере(НомерВыбраннойКарты)

	ВыбраннаяКнопка = Неопределено;
	Счетчик = 1;
	Для каждого ТекущаяКнопка Из Элементы.ПодменюВыборКарты.ПодчиненныеЭлементы Цикл
		
		Если Счетчик = НомерВыбраннойКарты Тогда
		
			ВыбраннаяКнопка = ТекущаяКнопка;
			ТекущаяКнопка.Пометка = Истина;
			
		Иначе
			ТекущаяКнопка.Пометка = Ложь;
		
		КонецЕсли;
				
		Счетчик = Счетчик+1;
	
	КонецЦикла;
		
	ТекущееМестоположение = Справочники.ItobМестоположенияПоУмолчанию.НайтиПоКоду(Сред(ВыбраннаяКнопка.Имя, 3));
	МестоположениеМасштаб = ТекущееМестоположение.Масштаб;
	МестоположениеШирота = ТекущееМестоположение.Широта;
	МестоположениеДолгота = ТекущееМестоположение.Долгота;
	
КонецПроцедуры // ИзменитьПодменюВыбораМестоположенияНаСервере()

// Процедура обрабатывает масштабирование карты.
//
&НаКлиенте
Процедура АвтоматическиМасштабироватьКарту()
	
	Если мСчетчикДокументСформирован < 1
		 ИЛИ НЕ Элементы.ПолеHTML.Документ.readyState = "complete" Тогда
		
		Возврат;	
	КонецЕсли;
	
	ТекстСкрипта = "";
	Если МестоположениеМасштаб <> 0 И МестоположениеШирота <> 0 И МестоположениеДолгота <> 0 Тогда
			
		ТекстСкрипта = 
			"var pt = new OpenLayers.LonLat("+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(МестоположениеДолгота)
				+", "+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(МестоположениеШирота)+");
			|pt.transform(m_map.displayProjection, m_map.getProjectionObject());
			|m_map.setCenter(pt, "+Формат(МестоположениеМасштаб,"ЧГ=0")+");
			|pt = null;";	
	КонецЕсли;	
	
	ItobОперативныйМониторингКлиент.ВыполнитьСкриптНаПолеHTML(Элементы.ПолеHTML, ТекстСкрипта);		

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСкриптТочкаНаКарте(Широта, Долгота, АдресСервера)
	
	Если НЕ ПроверитьКоординаты(Широта, Долгота) Тогда
		Возврат "";	
	КонецЕсли;
	
	ТекстСкрипта = 
	"var find_lays = m_map.getLayersByName(""Geometry"");
	|var vectorLayer = null;
	|if (find_lays.length == 0) {
	|	vectorLayer = new OpenLayers.Layer.Vector(""Geometry"", {displayInLayerSwitcher: false});
	|	m_map.addLayer(vectorLayer);
	|}
	|else {vectorLayer = find_lays[0];}
	|vectorLayer.destroyFeatures();
	|var Features = new Array;	
	|
	|var pt = new OpenLayers.LonLat("+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(Долгота)
		+", "+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(Широта)+");
	|pt.transform(m_map.displayProjection, m_map.getProjectionObject());			
	|var pointFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(pt.lon, pt.lat),null,{
	|					 graphicWidth: 16,
	|                    graphicHeight: 16,
	|                    graphicXOffset: -8,
	|                    graphicYOffset: -8,
	|                    externalGraphic: '"+АдресСервера+"images/unit.png',
	|                    graphicOpacity: 1
	|});			
	|Features.push(pointFeature);
	|vectorLayer.addFeatures(Features);";
				
				
	Возврат ТекстСкрипта;		

КонецФункции

&НаКлиенте
Процедура ПоказатьТочкуАдресаНаКарте(Широта, Долгота)
		
	Если мСчетчикДокументСформирован < 1
		 ИЛИ НЕ Элементы.ПолеHTML.Документ.readyState = "complete" Тогда
		
		Возврат;	
	КонецЕсли;
	
	ТекстСкрипта = ПолучитьСкриптТочкаНаКарте(Широта, Долгота, ВебСсылкаСервер);
			
	ItobОперативныйМониторингКлиент.ВыполнитьСкриптНаПолеHTML(Элементы.ПолеHTML, ТекстСкрипта);

КонецПроцедуры

&НаКлиенте
Процедура ВыборМестоположенияНаКартеОбработкаВыбораАдреса(ВыбранныйАдрес)
	
	Если мСчетчикДокументСформирован < 1
		ИЛИ Элементы.ПолеHTML.Документ = Неопределено
		ИЛИ НЕ Элементы.ПолеHTML.Документ.readyState = "complete" Тогда
		
		Возврат;	
	КонецЕсли;
	
	Если ТипЗнч(ВыбранныйАдрес) = Тип("Структура") Тогда
		АдресШирота   = ВыбранныйАдрес.Широта;
		АдресДолгота  = ВыбранныйАдрес.Долгота;
		
		// В случае успешного нахождения адреса, центрируем карту и сразу начинаем процедуру выбора пункта назначения.
		Если ПроверитьКоординаты(АдресШирота, АдресДолгота) Тогда			
			ТекстСкрипта = ПолучитьСкриптТочкаНаКарте(АдресШирота, АдресДолгота, ВебСсылкаСервер);  // *FIXIT* тест в спарке.	
			ТекстСкрипта = ТекстСкрипта + ГеометрияФиксацииПосещенияПриИзмененииНаСервере();
			
			ItobОперативныйМониторингКлиент.ВыполнитьСкриптНаПолеHTML(Элементы.ПолеHTML, ТекстСкрипта);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГеометрияФиксацииПосещенияПриИзменении(Элемент)
	
	УстановитьВидимостьРадиуса();
	
	ПодключитьОбработчикОжидания("ПриИзмененииГеометрииФиксацииПосещения", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииГеометрииФиксацииПосещения()
	
	Если НЕ СохранитьТочкиВТаблицу() Тогда
    	ПодключитьОбработчикОжидания("ПриИзмененииГеометрииФиксацииПосещения", 0.1, Истина);
		Возврат;
	КонецЕсли; 
	
	ТекстСкрипта = ГеометрияФиксацииПосещенияПриИзмененииНаСервере();
	ItobОперативныйМониторингКлиент.ВыполнитьСкриптНаПолеHTML(Элементы.ПолеHTML, ТекстСкрипта);
	
КонецПроцедуры

&НаСервере
Функция ГеометрияФиксацииПосещенияПриИзмененииНаСервере()
	
	Если НЕ ПроверитьКоординаты(АдресШирота, АдресДолгота) Тогда
		Возврат "";	
	КонецЕсли;
	
	Если ГеометрияФиксацииПосещения = Перечисления.ItobВидыГеометрииФиксацииПосещения.Окружность Тогда
		ТекстСкрипта = "
						|destroy_geozones_control();
						|destroy_pointcircle_control();
						|create_pointcircle_control("+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(АдресШирота)+", "
													 +ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(АдресДолгота)+", "
													 +Формат(РадиусФиксацииПосещения,"ЧРД=.; ЧГ=0")+");";
		
		
		Возврат ТекстСкрипта;
		
	ИначеЕсли ГеометрияФиксацииПосещения = Перечисления.ItobВидыГеометрииФиксацииПосещения.Полигон Тогда
		Если ТочкиПунктовНазначений.Количество() < 3 Тогда
			ТочкиПунктовНазначений.Очистить();
			РадиусФиксацииПосещения2 = РадиусФиксацииПосещения/2;
			ДобавитьТочкуВТаблицу(АдресШирота, АдресДолгота, РадиусФиксацииПосещения2, 45);
			ДобавитьТочкуВТаблицу(АдресШирота, АдресДолгота, РадиусФиксацииПосещения2, 135);
			ДобавитьТочкуВТаблицу(АдресШирота, АдресДолгота, РадиусФиксацииПосещения2, 225);
			ДобавитьТочкуВТаблицу(АдресШирота, АдресДолгота, РадиусФиксацииПосещения2, 315);
		КонецЕсли;
		
		Возврат "destroy_pointcircle_control();
				|"+ItobГеографическиеЗоныВызовСервера.ПолучитьСкриптОтображенияГеографическойЗоныСервер(ПунктНазначения, Ложь, ТочкиПунктовНазначений);
	КонецЕсли; 
	
КонецФункции
&НаСервере
Функция ДобавитьТочкуВТаблицу(БазоваяШирота, БазоваяДолгота, РадиусФиксацииПосещения2, Угол)
	ТекущийУголРадианы = ГрадусыВ_Радианы(Угол);
	СмещениеX = РадиусФиксацииПосещения2 * Sin(ТекущийУголРадианы);
	СмещениеY = РадиусФиксацииПосещения2 * Cos(ТекущийУголРадианы);

	СмещениеШирота = СмещениеX/(40000000/360)*Cos(ГрадусыВ_Радианы(БазоваяШирота));
	СмещениеДолгота = (СмещениеY/(40000000/360));

	ШиротаТочки = БазоваяШирота + СмещениеШирота;
	ДолготаТочки = БазоваяДолгота + СмещениеДолгота;
    
	Точка = ТочкиПунктовНазначений.Добавить();
	Точка.Широта = ШиротаТочки;
	Точка.Долгота = ДолготаТочки;
КонецФункции // ДобавитьТочкуВТаблицу()
  
// Перевод градусов в радианы.
//
// Параметры:
//  ВеличинаВ_Градусах  - Число - величина в градусах.
//
// Возвращаемое значение:
//  Число  - величина в радианах.
//
Функция ГрадусыВ_Радианы(ВеличинаВ_Градусах)
 Pi = 3.14159265358979323846264338327950288419716939937510; 
 Возврат Окр(Pi*Число(ВеличинаВ_Градусах)/180,12);	

КонецФункции // ГрадусыВ_Радианы()

&НаКлиенте
Функция СохранитьТочкиВТаблицу()
	
	Если мСчетчикДокументСформирован < 1
		 ИЛИ НЕ Элементы.ПолеHTML.Документ.readyState = "complete" Тогда
		
		Возврат Ложь;	
	КонецЕсли;
	
	// узнаем количество точек
	ItobОперативныйМониторингКлиент.ВыполнитьСкриптНаПолеHTML(Элементы.ПолеHTML,
							"if(geozones_control){document.form.result.value = geozones_control.handler.getPoints().length;}else{document.form.result.value = 0};");
	Если Элементы.ПолеHTML.Документ.forms.length = 0 Тогда
		Возврат Ложь;
	КонецЕсли; 
	ТекстТочек = Элементы.ПолеHTML.Документ.form.result.value;
	КоличествоТочек = Число(?(ТекстТочек = "", 0, ТекстТочек));
	
	Если КоличествоТочек > 0 Тогда
		МинШирота = 10000;
		МаксШирота = -10000;
		МинДолгота = 10000;
		МаксДолгота = -10000;
			
		ТочкиПунктовНазначений.Очистить();
	
		Для Счетчик = 0 По КоличествоТочек-1 Цикл
			ItobОперативныйМониторингКлиент.ВыполнитьСкриптНаПолеHTML(Элементы.ПолеHTML,
				"var pt = geozones_control.handler.getPoints()["+Формат(Счетчик, "ЧН=0; ЧГ=0")+"];
				|pt.transform(m_map.getProjectionObject(), m_map.displayProjection);
				|document.form.result.value = pt.toShortString();");
			Координаты = Элементы.ПолеHTML.Документ.form.result.value;
			Координаты = СтрЗаменить(Координаты, ", ", Символы.ПС);
			Точка = ТочкиПунктовНазначений.Добавить();
			Точка.Широта = СтрПолучитьСтроку(Координаты, 2);
			Точка.Долгота = СтрПолучитьСтроку(Координаты, 1);
			
			МинШирота = ItobОбщегоНазначенияКлиентСервер.МинЗнч(МинШирота, Точка.Широта);
			МаксШирота = ItobОбщегоНазначенияКлиентСервер.МаксЗнч(МаксШирота, Точка.Широта);
			МинДолгота = ItobОбщегоНазначенияКлиентСервер.МинЗнч(МинДолгота, Точка.Долгота);
			МаксДолгота = ItobОбщегоНазначенияКлиентСервер.МаксЗнч(МаксДолгота, Точка.Долгота);
		КонецЦикла;
		ItobОперативныйМониторингКлиент.ВыполнитьСкриптНаПолеHTML(Элементы.ПолеHTML, 
										"document.form.result.value = """";");
		АдресШирота = (МинШирота+МаксШирота)/2;
		АдресДолгота = (МинДолгота+МаксДолгота)/2;
	КонецЕсли;
	
	
	Возврат Истина;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПроверитьКоординаты(Координата1, Координата2 = 1, Координата3 = 1)
	
	Возврат (ПроверитьКоординату(Координата1) 
			 И ПроверитьКоординату(Координата2)
			 И ПроверитьКоординату(Координата3));
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПроверитьКоординату(Координата)
	
	Возврат НЕ (Координата = 0 ИЛИ Координата = Неопределено);
	
КонецФункции

&НаКлиенте
Процедура УстановитьВидимостьРадиуса()
	
	СкрытьРадиус = НЕ ГеометрияФиксацииПосещения = ПредопределенноеЗначение("Перечисление.ItobВидыГеометрииФиксацииПосещения.Окружность");
	
	Элементы.РадиусФиксацииПосещения.Видимость = Не СкрытьРадиус;
	
КонецПроцедуры

#КонецОбласти
