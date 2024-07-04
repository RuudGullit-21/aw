#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. процедуру ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию.
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;

КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//  
//  См. также:
//  "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
// Параметры:
//  Форма				 - УправляемаяФорма	 - Форма отчета.
//  Отказ				 - Булево			 - Передается из параметров обработчика "как есть".
//  СтандартнаяОбработка - Булево			 - Передается из параметров обработчика "как есть".
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ПараметрыДобавляемойКоманды = Новый Структура("Заголовок, Подсказка, Картинка, Отображение", 
	                                              "Калибровочный график",
												  "Открыть связанный с датчиком топлива калибровочный график",
												  БиблиотекаКартинок.Найти,
												  ОтображениеКнопки.КартинкаИТекст);
	Кнопка = ItobОбщегоНазначения.ДобавитьКнопкуНаФорму(Форма, 
														"ОткрытьКалибровочныйГрафик", 
														"Подключаемый_Команда", 
														Форма.Элементы.ОсновнаяКоманднаяПанель, 
														ПараметрыДобавляемойКоманды); 
	Форма.ПостоянныеКоманды.Добавить(Кнопка.Имя);
	
	
	ПараметрыФормы = ItobОтчетыКлиентСерверПовтИсп.ПараметрыФормы(Строка(Форма.УникальныйИдентификатор));
	ПараметрыФормы.Очистить();
	Если Форма.Параметры.Свойство("СписокПараметров") Тогда
		ПараметрыФормы.Вставить("Объект", Форма.Параметры.Объект);
		ПараметрыФормы.Вставить("СписокПараметров", Форма.Параметры.СписокПараметров);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после перезаполнения панели настроек формы отчета.
//
// Параметры:
//  Форма				 - УправляемаяФорма	 - Форма отчета.
//  ПервоеОткрытиеФормы	 - Булево - Признак первого открытия формы.
//
Процедура ИзменитьФормуПослеСозданияЭлементовНастроек(Форма, ПервоеОткрытиеФормы) Экспорт
	
	// Проверяем, открывается ли нужная форма.
	Если Не Форма.ТипФормыОтчета = ТипФормыОтчета.Основная Или СтрНайти(Форма.ИмяФормы, "ФормаОтчета") = 0 Тогда // Если используется общая форма из БСП проверяем на имя.
	    Возврат;
	КонецЕсли;
	
	// Настраиваем элемент "Объект".
	ЭлементОбъект = ItobОтчетыКлиентСервер.НайтиЭлементФормыПоЗаголовку(Форма, "Объект");
	ЭлементОбъект.КнопкаОткрытия = Истина;
	
	// Обновляем внешний вид элемента "Датчик топлива".
	ЭлементФормы = ItobОтчетыКлиентСервер.НайтиЭлементФормыПоЗаголовку(Форма, "Датчик топлива");
	ЭлементФормы.РежимВыбораИзСписка = Истина;
	ЭлементФормы.КнопкаОткрытия = Ложь;
	
	// Обновляем внешний вид элемента "Начало периода".
	ЭлементФормы = ItobОтчетыКлиентСервер.НайтиЭлементФормыПоЗаголовку(Форма, "Начало периода");
	ЭлементФормы.КнопкаРегулирования = Истина;
	ЭлементФормы.УстановитьДействие("Регулирование", "Подключаемый_ПолеВвода_Регулирование");
	
	// Обновляем внешний вид элемента "Конец периода".
	ЭлементФормы = ItobОтчетыКлиентСервер.НайтиЭлементФормыПоЗаголовку(Форма, "Конец периода");
	ЭлементФормы.КнопкаРегулирования = Истина;
	ЭлементФормы.УстановитьДействие("Регулирование", "Подключаемый_ПолеВвода_Регулирование");
	
	// Получаем из КЭШа параметры формы.
	ПараметрыФормы = ItobОтчетыКлиентСерверПовтИсп.ПараметрыФормы(Строка(Форма.УникальныйИдентификатор));
	
	// Заполняем список выбора датчика топлива.
	ОбъектИзВнешнихПараметров = Неопределено;
	Если ПараметрыФормы.Количество() > 0 И ПервоеОткрытиеФормы Тогда
		// Если форма отчета открыта с параметрами (например, через РМД), и это ее первое открытие, то указываем, что объект для построения отчета
		//	нужно взять не из текущих параметров формы отчета, а из внешних параметров.
		ОбъектИзВнешнихПараметров = ПараметрыФормы.Объект;
	КонецЕсли; 

	ItobОтчеты.ОтчетПоТопливу_ЗаполнитьСписокДатчиков(Форма, ОбъектИзВнешнихПараметров);
	
	// В данный модуль заходим несколько раз. Код, идущий ниже, должен выполняться только 1 раз,
	//	т.к. требуется для загрузки в форму отчета внешних параметров.
	Если НЕ ПервоеОткрытиеФормы Тогда	
		Возврат;
	КонецЕсли;	
	
	Если ПараметрыФормы.Количество() > 0 Тогда
		ПараметрыДанных = ItobОтчетыКлиентСервер.ПолучитьПараметрыДанных(Форма);
		
		// Заполняем передаваемые параметры.
		ItobОтчетыКлиентСервер.УстановитьЗначениеПараметра(ПараметрыДанных, "Объект", ПараметрыФормы.Объект, НСтр("ru = 'Объект'"));
		Для Каждого Параметр Из ПараметрыФормы.СписокПараметров Цикл
		    Если Параметр.Представление = "НачПериода" Тогда
			    ItobОтчетыКлиентСервер.УстановитьЗначениеПараметра(ПараметрыДанных, "НачПериода", Новый СтандартнаяДатаНачала(Параметр.Значение), НСтр("ru = 'Начало периода'; en = 'Beginning of period'"));
		    ИначеЕсли Параметр.Представление = "КонПериода" Тогда
			    ItobОтчетыКлиентСервер.УстановитьЗначениеПараметра(ПараметрыДанных, "КонПериода", Новый СтандартнаяДатаНачала(Параметр.Значение), НСтр("ru = 'Конец периода'; en = 'End of period'"));
		    ИначеЕсли Параметр.Представление = "Объект" Тогда
			    ItobОтчетыКлиентСервер.УстановитьЗначениеПараметра(ПараметрыДанных, "Объект", Параметр.Значение, НСтр("ru = 'Объект'"));
		    ИначеЕсли Параметр.Представление = "Метод" Тогда
			    ItobОтчетыКлиентСервер.УстановитьЗначениеПараметра(ПараметрыДанных, "Метод", Параметр.Значение, НСтр("ru = 'Метод'"));
			КонецЕсли; 
		КонецЦикла;
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура обработчик события "ПриКомпоновкеРезультата" объекта.
//
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", Истина);
	
	ПараметрыДанных = Настройки.ПараметрыДанных;
	
	НачПериода = ItobОтчетыКлиентСервер.ПолучитьЗначениеПараметра(ПараметрыДанных, "НачПериода", НСтр("ru = 'Начало периода'; en = 'Beginning of period'")).Дата;
	КонПериода = ItobОтчетыКлиентСервер.ПолучитьЗначениеПараметра(ПараметрыДанных, "КонПериода", НСтр("ru = 'Конец периода'; en = 'End of period'")).Дата;
	Метод = ItobОтчетыКлиентСервер.ПолучитьЗначениеПараметра(ПараметрыДанных, "Метод", НСтр("ru = 'Метод'"));
	Объект = ItobОтчетыКлиентСервер.ПолучитьЗначениеПараметра(ПараметрыДанных, "Объект", НСтр("ru = 'Объект'"));
	ДатчикТоплива = ItobОтчетыКлиентСервер.ПолучитьЗначениеПараметра(ПараметрыДанных, "ДатчикТоплива", НСтр("ru = 'Датчик топлива'"));
	
	Если НЕ ЗначениеЗаполнено(НачПериода)
		 ИЛИ НЕ ЗначениеЗаполнено(КонПериода) 
		 ИЛИ НЕ ЗначениеЗаполнено(Объект) 
		 ИЛИ НЕ ЗначениеЗаполнено(ДатчикТоплива) 
		 ИЛИ НЕ ЗначениеЗаполнено(Метод) Тогда
		 
		Возврат;
	КонецЕсли;
	
	
	ПараметрыДатчикаТоплива = ПолучитьПараметрыДатчикаТоплива(Объект, ДатчикТоплива, НачПериода);
	Терминал = ПараметрыДатчикаТоплива.Терминал;
	КалибровочныйГрафик = ПараметрыДатчикаТоплива.КалибровочныйГрафик;
	
	Если НЕ ЗначениеЗаполнено(Терминал) Тогда
		ВызватьИсключение НСтр("ru = 'К объекту не привязан терминал!'");
	КонецЕсли;
			
	Если НЕ ЗначениеЗаполнено(КалибровочныйГрафик) 
		 И НЕ ДатчикТоплива = "ПоВсем"  Тогда
		 
		ВызватьИсключение НСтр("ru = 'Для терминала объекта не указан калибровочный график!'");
	КонецЕсли;
		
	ТекстОшибки = "";
	ПараметрыПолученияТоплива = Новый Структура;
	ПараметрыПолученияТоплива.Вставить("НачПериода", НачПериода);
	ПараметрыПолученияТоплива.Вставить("КонПериода ", КонПериода);
	ПараметрыПолученияТоплива.Вставить("Объект", Объект);
	ПараметрыПолученияТоплива.Вставить("Метод", Метод);
	
	ТаблицаДанные = Неопределено;
	ТаблицаЗаправки = Неопределено;
	ItobОбработкаДанныхТопливоВызовСервера.ПолучитьДанныеТопливо(ПараметрыПолученияТоплива, 
																 ТаблицаДанные, 
																 ТаблицаЗаправки, 
																 ТекстОшибки, 
																 ДатчикТоплива);
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда 															 
		ВызватьИсключение ТекстОшибки;		
	КонецЕсли;
	
	Если ТаблицаДанные.Количество() = 0 Тогда
		ВызватьИсключение "Данных по топливу не обнаружено";		
	КонецЕсли; 
	
	// Отчет состоит из трех независимых наборов данных: данные по топливу (график), данные по заправкам, итоговые данные.
	//	Сначала идет подготовка данных по топливу.
	ТаблицаДанные.Колонки.Добавить("СекундСНачалаПериода", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0)));
	ТаблицаДанные.Колонки.Добавить("МинПериод", Новый ОписаниеТипов("Дата"));

	ТаблицаДанные.ЗаполнитьЗначения(ТаблицаДанные[0].Период, "МинПериод");
	
	Для каждого Стр Из ТаблицаДанные Цикл		
		Стр.СекундСНачалаПериода = Стр.Период - Стр.МинПериод;
	КонецЦикла;
	
	// Затем - подготовка данных по заправкам.
	ТаблицаЗаправки.Колонки.Добавить("ТопливоПриход", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 5)));
	ТаблицаЗаправки.Колонки.Добавить("ТопливоРасход", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 5)));
	ТаблицаЗаправки.Колонки.Добавить("Место", Новый ОписаниеТипов("Строка"));
	ИтогоТопливоПриход = 0;
	ИтогоТопливоРасход = 0;
	Для каждого СтрСливыЗаправки Из ТаблицаЗаправки Цикл
		СтрСливыЗаправки.ТопливоПриход = ?(СтрСливыЗаправки.ТопливоИзменение >= 0, СтрСливыЗаправки.ТопливоИзменение, 0);
		СтрСливыЗаправки.ТопливоРасход = ?(СтрСливыЗаправки.ТопливоИзменение < 0, -СтрСливыЗаправки.ТопливоИзменение, 0);
				
		СтрСливыЗаправки.Место = ItobОперативныйМониторинг.НайтиБлижайшийАдрес(СтрСливыЗаправки.Широта, СтрСливыЗаправки.Долгота);
		
		ИтогоТопливоПриход = ИтогоТопливоПриход + СтрСливыЗаправки.ТопливоПриход;
		ИтогоТопливоРасход = ИтогоТопливоРасход + СтрСливыЗаправки.ТопливоРасход;
	КонецЦикла;
	
	// И, наконец, собираются итоговые данные.
	МассивДанныхТопливо = ТаблицаДанные.ВыгрузитьКолонку("ЗначениеСглаженное");
	МассивДанныхНач = ItobОбработкаДанныхТопливоВызовСервера.ВыделитьЧастьМассива(МассивДанныхТопливо, 3, 3, -1);
	ОбъемНаНачало = ItobОбработкаДанныхТопливоВызовСервера.ПолучитьМедиану(МассивДанныхНач);
	
	Если Метод= "Пробег" Тогда
		ПробегОбщий = ItobОперативныйМониторинг.ПолучитьПробегОбъекта(Объект, НачПериода, КонПериода);		
	Иначе
		ПробегОбщий = ТаблицаДанные[ТаблицаДанные.Количество()-1].Пробег;
	КонецЕсли;
	
	ОбъемНаКонец = ТаблицаДанные[ТаблицаДанные.Количество()-1].ЗначениеСглаженное;
	ОбщийРасходТоплива = ОбъемНаНачало - ОбъемНаКонец + ИтогоТопливоПриход-ИтогоТопливоРасход;
	
	ИтоговыеДанные = Новый ТаблицаЗначений;
	ИтоговыеДанные.Колонки.Добавить("ОбъемНаНачало", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0)));
	ИтоговыеДанные.Колонки.Добавить("ОбъемНаКонец", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0)));
	ИтоговыеДанные.Колонки.Добавить("ОбщийРасходТоплива", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0)));
	ИтоговыеДанные.Колонки.Добавить("ПробегОбщий", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 5)));
	ИтоговыеДанные.Колонки.Добавить("СредКоэффициентРасхода", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 5)));
	
	НовСтрокаИтоги = ИтоговыеДанные.Добавить();

	НовСтрокаИтоги.ОбъемНаНачало = Окр(ОбъемНаНачало, 0);
	НовСтрокаИтоги.ОбъемНаКонец = Окр(ОбъемНаКонец, 0);
	НовСтрокаИтоги.ОбщийРасходТоплива = Окр(ОбщийРасходТоплива, 0);
	НовСтрокаИтоги.ПробегОбщий = ПробегОбщий;
	НовСтрокаИтоги.СредКоэффициентРасхода = ?(ПробегОбщий < 0.1, 
											  0, 
											  ОбщийРасходТоплива / (ПробегОбщий / ?(Метод = "Пробег", 100, 1)));
		
	// Создание внешнего объекта для использования в СКД.
	ВнешниеДанные = Новый Структура;
	ВнешниеДанные.Вставить("ДанныеПоТопливу", ТаблицаДанные);
	ВнешниеДанные.Вставить("ДанныеПоЗаправкам", ТаблицаЗаправки);
	ВнешниеДанные.Вставить("ИтоговыеДанные", ИтоговыеДанные);
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;	
	
	НастройкаОсиШкалыТочек = ItobОтчеты.НайтиНастройкуОсиШкалыТочек(Настройки);
	Если НЕ НастройкаОсиШкалыТочек = Неопределено Тогда
		НастройкаОсиШкалыТочек.МинимальноеЗначение = НачПериода;
		НастройкаОсиШкалыТочек.МаксимальноеЗначение = КонПериода;	
	КонецЕсли; 
	
	// Компоновка макета.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеДанные, ДанныеРасшифровки, Истина);
	
	// Вывод данных.
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
 
Функция ПолучитьПараметрыДатчикаТоплива(ТекущийОбъект, Назначение, НачПериода)
	
	Возврат ItobОтчеты.ПолучитьПараметрыДатчикаТоплива(ТекущийОбъект, Назначение, НачПериода);
	
КонецФункции

#КонецОбласти 

#КонецЕсли
